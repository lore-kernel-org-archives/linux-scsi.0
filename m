From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Sat, 9 Jun 2012 16:57:26 -0700
Message-ID: <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
	<4FD345DC.6020405@acm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3079ba3af5576304c212e069
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FD345DC.6020405@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--20cf3079ba3af5576304c212e069
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Jun 9, 2012 at 5:47 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On 06/09/12 00:10, Muthu Kumar wrote:
>
>> Since the queue->lock case is taken care of in the following patch:
>>
>> (http://www.spinics.net/lists/linux-scsi/msg59845.html [PATCH 1/4]
>> block: Fix race on request_queue.end_io invocations)
>>
>> Updated the patch with just the end_io assignment before dead queue check.
>>
>>
>
>
> This patch does not apply since it's line-wrapped and a part is missing
> in the second hunk. However, if I had overlooked your original patch
> then I want to apologize.
>

Please use the attached file since gmail messes with the line wraps.

> If you can resend your original patch including the locking changes then
> I'll test it further.
>

Locking change is the one you posted already (the link above). Anyway,
I have the attached patch *including* the locking change. Original
mail has attachment without locking change. Please use whatever you
need.
Thanks for testing.

Regards,
Muthu


> Bart.

--20cf3079ba3af5576304c212e069
Content-Type: text/x-diff; charset=US-ASCII; name="blk-exec-patch-to-bart.patch"
Content-Disposition: attachment; filename="blk-exec-patch-to-bart.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h39cda0y0

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1leGVjLmMgYi9ibG9jay9ibGstZXhlYy5jCmluZGV4IGZi
MmNiZDUuLjI4NGJmNTYgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2Jsay1leGVjLmMKKysrIGIvYmxvY2sv
YmxrLWV4ZWMuYwpAQCAtNTMsMTYgKzUzLDE3IEBAIHZvaWQgYmxrX2V4ZWN1dGVfcnFfbm93YWl0
KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgZ2VuZGlzayAqYmRfZGlzaywKIAlXQVJO
X09OKGlycXNfZGlzYWJsZWQoKSk7CiAJc3Bpbl9sb2NrX2lycShxLT5xdWV1ZV9sb2NrKTsKIAor
CXJxLT5ycV9kaXNrID0gYmRfZGlzazsKKwlycS0+ZW5kX2lvID0gZG9uZTsKKwogCWlmICh1bmxp
a2VseShibGtfcXVldWVfZGVhZChxKSkpIHsKLQkJc3Bpbl91bmxvY2tfaXJxKHEtPnF1ZXVlX2xv
Y2spOwogCQlycS0+ZXJyb3JzID0gLUVOWElPOwogCQlpZiAocnEtPmVuZF9pbykKIAkJCXJxLT5l
bmRfaW8ocnEsIHJxLT5lcnJvcnMpOworCQlzcGluX3VubG9ja19pcnEocS0+cXVldWVfbG9jayk7
CiAJCXJldHVybjsKIAl9CiAKLQlycS0+cnFfZGlzayA9IGJkX2Rpc2s7Ci0JcnEtPmVuZF9pbyA9
IGRvbmU7CiAJX19lbHZfYWRkX3JlcXVlc3QocSwgcnEsIHdoZXJlKTsKIAlfX2Jsa19ydW5fcXVl
dWUocSk7CiAJLyogdGhlIHF1ZXVlIGlzIHN0b3BwZWQgc28gaXQgd29uJ3QgYmUgcnVuICovCg==
--20cf3079ba3af5576304c212e069--
