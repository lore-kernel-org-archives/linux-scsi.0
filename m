From: adam radford <aradford@gmail.com>
Subject: Re: megaraid_sas: which patches are needed for 2.6.32.y?
Date: Fri, 29 Jun 2012 09:25:42 -0700
Message-ID: <CAHtARFHafR+hrB4u=wDUSE3-J2uXOQCFHW3wRSQMiebowu-9iA@mail.gmail.com>
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
	<20120628202743.GA7295@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60649 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab2F2QZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2012 12:25:44 -0400
Received: by wgbdr13 with SMTP id dr13so3200871wgb.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jun 2012 09:25:42 -0700 (PDT)
In-Reply-To: <20120628202743.GA7295@burratino>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, Buford Peek <BPeek@lancope.com>, 666108@bugs.debian.org, Gator_Yin@dell.com, linux-scsi@vger.kernel.org

On Thu, Jun 28, 2012 at 1:27 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:
...
> If someone makes a backport of the patches marked [3] as well, would
> you be able to look over or test the combination?  That would be much
> appreciated.  If that's not possible, your advice would still be
> welcome but we will need to use a more minimal set of changes.

Yes, I will be able to look over and/or test the combination.  If you
apply all patches then diff vs. the scsi-misc tip, you should only see
kernel 2.6.32.y specific changes.

-Adam
