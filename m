From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH v2] cmdfilter: clean up sysfs interface
Date: Fri, 8 Aug 2008 14:05:08 +0200
Message-ID: <6cf6b73e0808080505v5989bd3bm7beedea2b443bc55@mail.gmail.com>
References: <6cf6b73e0808020819x4501aa1cud4e6c3c9ae77558b@mail.gmail.com>
	 <20080808160629H.fujita.tomonori@lab.ntt.co.jp>
	 <6cf6b73e0808080047i550f2e6bt71d4e213f81fea87@mail.gmail.com>
	 <20080808174508Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:10247 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbYHHMFJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 08:05:09 -0400
Received: by rv-out-0506.google.com with SMTP id k40so996622rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Aug 2008 05:05:08 -0700 (PDT)
In-Reply-To: <20080808174508Z.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, matthew@wil.cx, pjones@redhat.com, dougg@torque.net, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com

2008/8/8 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Fri, 8 Aug 2008 09:47:44 +0200
> "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
>
>> > strchr(str, ' ') would make the intention clear here rather than using
>> > '4' ?
>>
>> yeah will do that
>
> Actually you don't need strchr here. You can just use simple_strtol.
>

yeah that makes sense.
