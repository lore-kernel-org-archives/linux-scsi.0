From: adam radford <aradford@gmail.com>
Subject: Re: megaraid_sas: which patches are needed for 2.6.32.y?
Date: Thu, 28 Jun 2012 12:19:36 -0700
Message-ID: <CAHtARFH=kmVO_xWs+DafPuWd+wPFnP-Cw5vTVRR-Pd3+xDxkzw@mail.gmail.com>
References: <FB09F9AF3FE25444B277AA82BB35EE175F0260C0@LCHQEX03.lancope.local>
	<20120328192623.GB8982@burratino>
	<FB09F9AF3FE25444B277AA82BB35EE175F02612C@LCHQEX03.lancope.local>
	<FB09F9AF3FE25444B277AA82BB35EE175F028482@LCHQEX03.lancope.local>
	<20120329165806.GC3147@burratino>
	<FB09F9AF3FE25444B277AA82BB35EE175F0284E2@LCHQEX03.lancope.local>
	<20120329194751.GG3147@burratino>
	<20120609164753.GA18761@burratino>
	<20120624151318.GA18451@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58227 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2F1TTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jun 2012 15:19:38 -0400
Received: by werb14 with SMTP id b14so647120wer.19
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jun 2012 12:19:36 -0700 (PDT)
In-Reply-To: <20120624151318.GA18451@burratino>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, Buford Peek <BPeek@lancope.com>, 666108@bugs.debian.org, Gator_Yin@dell.com, linux-scsi@vger.kernel.org

On Sun, Jun 24, 2012 at 8:13 AM, Jonathan Nieder <jrnieder@gmail.com> w=
rote:
=2E..
>> Questions:
>>
>> 1) Are any of these important fixes that should be applied to 2.6.32=
=2Ey
>> =A0 =A0so everyone who uses a 2.6.32-based kernel can start benefitt=
ing
>> =A0 =A0from them?

If you have already backported the patches from list 2 to Debian
2.6.32.x kernel, please also backport the patches from list 3.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
