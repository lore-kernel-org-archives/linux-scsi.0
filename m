From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH v2 1/7] ibmvscsi: Correct values for several viosrp_crq_format
 enums
Date: Wed, 10 Feb 2016 19:32:22 -0600
Message-ID: <1455154348-3226-2-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, manoj@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, jthumshirn@suse.de, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

VGhlIGVudW0gdmFsdWVzIGZvciBWSU9TUlBfTElOVVhfRk9STUFUIGFuZCBWSU9TUlBfSU5MSU5F
X0ZPUk1BVCBhcmUKb2ZmIGJ5IG9uZS4gVGhleSBhcmUgY3VycmVudGx5IGRlZmluZWQgYXMgMHgw
NiBhbmQgMHgwNyByZXNwZXRpdmVseS4KVGhlc2UgdmFsdWVzIGFyZSBkZWZpbmVkIGluIFBBUFIg
Y29ycmVjdGx5IGFzIDB4MDUgYW5kIDB4MDYuIFRoaXMKaW5jb25zaXN0ZW5jeSBoYXMgZ29uZSB1
bm5vdGljZWQgYXMgbmVpdGhlciBlbnVtIGlzIGN1cnJlbnRseSB1c2VkLgpUaGUgcG9zc2libGUg
ZnV0dXJlIHN1cHBvcnQgb2YgUElORyBtZXNzYWdlcyBiZXR3ZWVuIHRoZSBWSU9TIGFuZApjbGll
bnQgYWRhcHRlciByZWxpZXMgb24gVklPU1JQX0lOTElORV9GT1JNQVQgY3JxIG1lc3NhZ2VzLgpD
b3JyZWN0ZWQgdGhlc2UgZW51bSB2YWx1ZXMgdG8gbWF0Y2ggUEFQUiBkZWZpbml0aW9ucy4KClNp
Z25lZC1vZmYtYnk6IFR5cmVsIERhdHd5bGVyIDx0eXJlbGRAbGludXgudm5ldC5pYm0uY29tPgpS
ZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGh1bXNoaXJuQHN1c2UuZGU+Ci0tLQog
ZHJpdmVycy9zY3NpL2libXZzY3NpL3Zpb3NycC5oIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS9pYm12c2NzaS92aW9zcnAuaCBiL2RyaXZlcnMvc2NzaS9pYm12c2NzaS92aW9zcnAuaAppbmRl
eCAxMTYyNDMwLi5kMTA0NGU5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvaWJtdnNjc2kvdmlv
c3JwLmgKKysrIGIvZHJpdmVycy9zY3NpL2libXZzY3NpL3Zpb3NycC5oCkBAIC01Niw4ICs1Niw4
IEBAIGVudW0gdmlvc3JwX2NycV9mb3JtYXRzIHsKIAlWSU9TUlBfTUFEX0ZPUk1BVCA9IDB4MDIs
CiAJVklPU1JQX09TNDAwX0ZPUk1BVCA9IDB4MDMsCiAJVklPU1JQX0FJWF9GT1JNQVQgPSAweDA0
LAotCVZJT1NSUF9MSU5VWF9GT1JNQVQgPSAweDA2LAotCVZJT1NSUF9JTkxJTkVfRk9STUFUID0g
MHgwNworCVZJT1NSUF9MSU5VWF9GT1JNQVQgPSAweDA1LAorCVZJT1NSUF9JTkxJTkVfRk9STUFU
ID0gMHgwNgogfTsKIAogZW51bSB2aW9zcnBfY3JxX3N0YXR1cyB7Ci0tIAoyLjUuMAoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXhwcGMtZGV2IG1h
aWxpbmcgbGlzdApMaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZwpodHRwczovL2xpc3RzLm96
bGFicy5vcmcvbGlzdGluZm8vbGludXhwcGMtZGV2
