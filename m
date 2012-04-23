From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 03/12] libata, libsas: introduce sched_eh and end_eh port ops
Date: Mon, 23 Apr 2012 15:49:49 -0700
Message-ID: <CABE8wwsmuRqzW7yiR=jWriEnxsH+koxSooQ18cqDP2ver54mCg@mail.gmail.com>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	<20120413233706.8025.56546.stgit@dwillia2-linux.jf.intel.com>
	<1335115828.13208.31.camel@dabdike.lan>
	<4F94BF90.4090001@garzik.org>
	<1335168621.3051.8.camel@dabdike.lan>
	<CABE8wwtd2c14dq8vWCtO_rEvk8i8Q8GzJ3NtS_YQVmpTUaF3=w@mail.gmail.com>
	<1335219777.2749.11.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:44168 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753017Ab2DWWtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 18:49:53 -0400
Received: by bkcji2 with SMTP id ji2so34885bkc.25
        for <linux-scsi@vger.kernel.org>; Mon, 23 Apr 2012 15:49:50 -0700 (PDT)
In-Reply-To: <1335219777.2749.11.camel@dabdike.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

On Mon, Apr 23, 2012 at 3:22 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>> No, it means:
>>
>> "If a person was not directly involved in the preparation or handlin=
g of a
>> patch but wishes to signify and record their approval of it then the=
y can
>> arrange to have an Acked-by: line added to the patch's changelog."
>
> Isn't that tested-by or reviewed-by?

Quoting from Documentation/SubmittingPatches was just a tongue in
cheek way of pointing out that you have a local/narrower
interpretation of Acked-by, and that Jacek's Acked-by is consistent
with what's documented.

[..]
> We're just struggling to understand why it's there. =A0If it's read a=
nd
> approved the patch, then reviewed-by is the more appropriate. =A0If i=
t's
> actually booted and ran through a set of unit/QA tests, then it shoul=
d
> be tested-by.
>

Ok, reviewed-by is what we'll aim to do for Intel-internal "acks" for
isci / libsas going forward.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
