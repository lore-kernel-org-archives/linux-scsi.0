From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: megaraid_sas: which patches are needed for 2.6.32.y?
Date: Thu, 28 Jun 2012 15:27:43 -0500
Message-ID: <20120628202743.GA7295@burratino>
References: <FB09F9AF3FE25444B277AA82BB35EE175F0260C0@LCHQEX03.lancope.local>
 <20120328192623.GB8982@burratino>
 <FB09F9AF3FE25444B277AA82BB35EE175F02612C@LCHQEX03.lancope.local>
 <FB09F9AF3FE25444B277AA82BB35EE175F028482@LCHQEX03.lancope.local>
 <20120329165806.GC3147@burratino>
 <FB09F9AF3FE25444B277AA82BB35EE175F0284E2@LCHQEX03.lancope.local>
 <20120329194751.GG3147@burratino>
 <20120609164753.GA18761@burratino>
 <20120624151318.GA18451@burratino>
 <CAHtARFH=kmVO_xWs+DafPuWd+wPFnP-Cw5vTVRR-Pd3+xDxkzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34549 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1U2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jun 2012 16:28:02 -0400
Received: by gglu4 with SMTP id u4so2209130ggl.19
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jun 2012 13:28:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAHtARFH=kmVO_xWs+DafPuWd+wPFnP-Cw5vTVRR-Pd3+xDxkzw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, Buford Peek <BPeek@lancope.com>, 666108@bugs.debian.org, Gator_Yin@dell.com, linux-scsi@vger.kernel.org

adam radford wrote:
> On Sun, Jun 24, 2012 at 8:13 AM, Jonathan Nieder <jrnieder@gmail.com>=
 wrote:

>>> Questions:
>>>
>>> 1) Are any of these important fixes that should be applied to 2.6.3=
2.y
>>> =C2=A0 =C2=A0so everyone who uses a 2.6.32-based kernel can start b=
enefitting
>>> =C2=A0 =C2=A0from them?
>
> If you have already backported the patches from list 2 to Debian
> 2.6.32.x kernel, please also backport the patches from list 3.

Debian's squeeze kernel currently only has the five patches marked [1].

The patches marked [2] have been backported and tested but not applied
(waiting on advice from knowledgeable folks such as you :)).

If someone makes a backport of the patches marked [3] as well, would
you be able to look over or test the combination?  That would be much
appreciated.  If that's not possible, your advice would still be
welcome but we will need to use a more minimal set of changes.

Thanks,
Jonathan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
