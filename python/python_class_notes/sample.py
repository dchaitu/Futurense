# def prepare_messages(payloads, min_length=3):
#     result = {"token_lists": [], "vocabulary": [], "rejected_indices": []}
#     for payload in payloads:
#         payload_index = payloads.index(payload)
#         if type(payload) == str:
#             payload = payload.strip()
#             tokens = payload.split()
#             print(tokens)
#             for token in tokens:
#                 token = remove_spl_chars(token)
#                 print(token)
#                 if len(token) >= min_length:
#                     # result.append({"token_lists": token, "vocabulary": list(set(tokens))})
#                     # token_lists.append(token)
#                     token_lists
#
#
#                 else:
#                     # result["rejected_indices"] = [payload_index]
#                     # result.append({"rejected_indices": [payload_index]})
#                     result["token_lists"] = token_lists
#         else:
#             # result["rejected_indices"] = [payload_index]
#             # result.append({"rejected_indices": [payload_index]})
#     return result