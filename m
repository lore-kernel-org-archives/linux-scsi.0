From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH 0/6] scsi: bfa: Use y2038 safe timestamps
Date: Sat, 9 Jan 2016 19:52:46 +0530
Message-ID: <20160109142246.GA7316@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org
List-Id: linux-scsi@vger.kernel.org

MzIgYml0IHN5c3RlbXMgdXNpbmcgJ3N0cnVjdCB0aW1ldmFsJyB3aWxsIGJyZWFrIGluIHRoZSB5
ZWFyIDIwMzgsIHNvCnRoZXNlIGZpbGVzIGhhdmUgYmVlbiBtb2RpZmllZCBhcHByb3ByaWF0ZWx5
IHRvIG1ha2UgdGhlbSB5MjAzOCBzYWZlLgoKQW1pdG9qIEthdXIgQ2hhd2xhICg2KToKICBzY3Np
OiBiZmE6IGJmYV9zdmM6IFVzZSBrdGltZV9nZXRfcmVhbF9zZWNvbmRzKCkKICBzY3NpOiBiZmE6
IGJmYV9zdmM6IFJlbW92ZSAnc3RydWN0IHRpbWV2YWwnCiAgc2NzaTogYmZhOiBVc2UgJ2t0aW1l
X2dldF9yZWFsX3NlY29uZHMoKScKICBzY3NpOiBiZmE6IFJlbW92ZSB1c2Ugb2YgdGltZV90CiAg
c2NzaTogYmZhOiBiZmFfcG9ydDogUmVtb3ZlICdzdHJ1Y3QgdGltZXZhbCcKICBzY3NpOiBiZmE6
IGJmYV9jczogUmVtb3ZlIHN0cnVjdCB0aW1ldmFsCgogZHJpdmVycy9zY3NpL2JmYS9iZmFfY3Mu
aCAgICAgICB8ICA4ICstLS0tLS0tCiBkcml2ZXJzL3Njc2kvYmZhL2JmYV9kZWZzX3N2Yy5oIHwg
IDQgKysrKwogZHJpdmVycy9zY3NpL2JmYS9iZmFfZmNwaW0uYyAgICB8ICA3ICsrKystLS0KIGRy
aXZlcnMvc2NzaS9iZmEvYmZhX2ZjcGltLmggICAgfCAgNCArKy0tCiBkcml2ZXJzL3Njc2kvYmZh
L2JmYV9wb3J0LmMgICAgIHwgMTYgKysrKy0tLS0tLS0tLS0tLQogZHJpdmVycy9zY3NpL2JmYS9i
ZmFfcG9ydC5oICAgICB8ICAyICstCiBkcml2ZXJzL3Njc2kvYmZhL2JmYV9zdmMuYyAgICAgIHwg
MzYgKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3Njc2kvYmZh
L2JmYWRfYnNnLmMgICAgIHwgIDYgKysrLS0tCiA4IGZpbGVzIGNoYW5nZWQsIDMxIGluc2VydGlv
bnMoKyksIDUyIGRlbGV0aW9ucygtKQoKLS0gCjEuOS4xCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMu
bGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAz
OAo=
