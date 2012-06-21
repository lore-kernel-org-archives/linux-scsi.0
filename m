From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Thu, 21 Jun 2012 14:40:28 -0700
Message-ID: <CAFR8uecUUVD3Ra4ajNxMi=37LKWd7T46_xLR6C2=47MWZ6K=9Q@mail.gmail.com>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
	<4FD345DC.6020405@acm.org>
	<CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
	<4FD4DC26.5080902@acm.org>
	<CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com>
	<CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com>
	<20120618224253.GH32733@google.com>
	<4FE21C15.6040409@acm.org>
	<CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com>
	<4FE2B3D1.6070504@acm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf307f39aa43469704c3025db1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FE2B3D1.6070504@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--20cf307f39aa43469704c3025db1
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jun 20, 2012 at 10:40 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> On 06/21/12 00:53, Muthu Kumar wrote:
>
>> Hmm... Shouldn't this be:
>>
>> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
>> Tested-by: Bart Van Assche <bvanassche@acm.org>
>
>
> I'll modify that part of the patch if you prefer to be mentioned as the
> author. I hadn't done that because you hadn't posted the patch in its
> entirety yet.
>
>

Its been in the attachment in all my previous mails, since gmail and
patches in-line doesn't go well. Anyway, I have attached the patch
with this again (v3). Thanks.

>> This part already went in, its here only for testing - So in the final
>> patch, before applying this should be removed.
>
>
> When did it go in ? As far as I can see that patch is not yet present in
> Linus' tree nor in James' tree.
>

My bad. I thought Jens/James took it already... may be not.

Regards,
Muthu

> Bart.

--20cf307f39aa43469704c3025db1
Content-Type: application/octet-stream;
	name="blk-exec-assign-endio-to-bart-v3.patch"
Content-Disposition: attachment;
	filename="blk-exec-assign-endio-to-bart-v3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3qcq8400

LS0tLS0tLS0KW1BBVENIXSBibG9jazogYmxrX2V4ZWN1dGVfcnFfbm93YWl0KCk6IGluaXQgcnEt
PmVuZF9pbyBiZWZvcmUgY2hlY2tpbmcgZm9yIGRlYWQgcXVldWUuCgpibGstZXhlYy5jOiBJbiBi
bGtfZXhlY3V0ZV9ycV9ub3dhaXQoKSwgaWYgdGhlIHF1ZXVlIGlzIGRlYWQsIGNhbGwgdG8KZG9u
ZSgpIHJvdXRpbmUgaXMgbm90IG1hZGUuIFRoYXQgd2lsbCByZXN1bHQgaW4gYmxrX2V4ZWN1dGVf
cnEoKSBzdHVjawppbiB3YWl0X2Zvcl9jb21wbGV0aW9uKCkuIEF2b2lkIHRoaXMgYnkgaW5pdGlh
bGl6aW5nIHJxLT5lbmRfaW8gdG8KZG9uZSgpIHJvdXRpbmUgYmVmb3JlIHdlIGNoZWNrIGZvciBk
ZWFkIHF1ZXVlLgoKU2lnbmVkLW9mZi1ieTogTXV0aHVrdW1hciBSYXR0eSA8bXV0aHVyQGdtYWls
LmNvbT4KVGVzdGVkLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4KQ0M6
IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KQ0M6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5k
az4KQ0M6IEphbWVzIEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5QGhhbnNlbnBhcnRuZXJzaGlw
LmNvbT4KCi0tLS0tLS0tCmRpZmYgLS1naXQgYS9ibG9jay9ibGstZXhlYy5jIGIvYmxvY2svYmxr
LWV4ZWMuYwppbmRleCBmYjJjYmQ1Li4wMGE3MmRhIDEwMDY0NAotLS0gYS9ibG9jay9ibGstZXhl
Yy5jCisrKyBiL2Jsb2NrL2Jsay1leGVjLmMKQEAgLTUxLDYgKzUxLDEwIEBAIHZvaWQgYmxrX2V4
ZWN1dGVfcnFfbm93YWl0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgZ2VuZGlzayAq
YmRfZGlzaywKIAlpbnQgd2hlcmUgPSBhdF9oZWFkID8gRUxFVkFUT1JfSU5TRVJUX0ZST05UIDog
RUxFVkFUT1JfSU5TRVJUX0JBQ0s7CiAKIAlXQVJOX09OKGlycXNfZGlzYWJsZWQoKSk7CisKKwly
cS0+cnFfZGlzayA9IGJkX2Rpc2s7CisJcnEtPmVuZF9pbyA9IGRvbmU7CisKIAlzcGluX2xvY2tf
aXJxKHEtPnF1ZXVlX2xvY2spOwogCiAJaWYgKHVubGlrZWx5KGJsa19xdWV1ZV9kZWFkKHEpKSkg
ewpAQCAtNjEsOCArNjUsNiBAQCB2b2lkIGJsa19leGVjdXRlX3JxX25vd2FpdChzdHJ1Y3QgcmVx
dWVzdF9xdWV1ZSAqcSwgc3RydWN0IGdlbmRpc2sgKmJkX2Rpc2ssCiAJCXJldHVybjsKIAl9CiAK
LQlycS0+cnFfZGlzayA9IGJkX2Rpc2s7Ci0JcnEtPmVuZF9pbyA9IGRvbmU7CiAJX19lbHZfYWRk
X3JlcXVlc3QocSwgcnEsIHdoZXJlKTsKIAlfX2Jsa19ydW5fcXVldWUocSk7CiAJLyogdGhlIHF1
ZXVlIGlzIHN0b3BwZWQgc28gaXQgd29uJ3QgYmUgcnVuICovCg==
--20cf307f39aa43469704c3025db1--
