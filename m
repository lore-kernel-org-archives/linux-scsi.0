From: Vaibhav Nipunage <vaibhavnipunage@gmail.com>
Subject: Re: Mode Pages implementaion
Date: Fri, 24 Apr 2009 18:54:59 +0530
Message-ID: <51b3a25b0904240624n90f7392ve9d95d4d28667f3e@mail.gmail.com>
References: <23213776.post@talk.nabble.com>
	 <20090424122342.GZ1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:4408 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbZDXNZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 09:25:01 -0400
Received: by yw-out-2324.google.com with SMTP id 5so652042ywb.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2009 06:25:00 -0700 (PDT)
In-Reply-To: <20090424122342.GZ1926@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Thanks Matthew for you help.

I will go through the SPC-4 and read about it.

But I tried the same (above) thing and try to connect the target
through open iscsi initiator.In this case on target got 4 as a
allocation length (for page of 3f). So how to respond information of
all pages in those 4 bytes? or any thing wrong is happening? Correct
me if I am wrong.

Thanks once again.

On Fri, Apr 24, 2009 at 5:53 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, Apr 24, 2009 at 03:26:10AM -0700, VaibhavNipunage wrote:
>> When initiator sends Mode Sense (0x1Ah) with requested page opcode (=
0x3F :
>> all pages), then at that time on target side, target got the Allocat=
ion
>> Length as 192. I dont know why it is getting 192 size. I read PC-3 d=
oc,
>> according to that target should receive 256 (for MODE SENSE 6) or 65=
,536
>> (for MODE SENSE 10). I am confused why this is happening?
>
> Allocation Length is the amount of space the initiator has available
> for the response. =A0It can be any length (including zero, which SPC4=
 is
> very clear is not an error). =A0See section 4.3.5.6 Allocation length=
 in
> spc4r14 or 4.3.4.6 Allocation length in spc3r23.
>
> --
> Matthew Wilcox =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Int=
el Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours. =A0We can't possibly take s=
uch
> a retrograde step."
>



--=20
Vaibhav Nipunage
Systems Engineer

QualEx Systems Pvt. Ltd.
www.qualexsystems.com
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
