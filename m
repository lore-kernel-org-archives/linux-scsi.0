From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: megaraid_sas: which patches are needed for 2.6.32.y?
Date: Mon, 29 Oct 2012 04:50:49 -0700
Message-ID: <20121029115049.GA28465@elie.Belkin>
References: <FB09F9AF3FE25444B277AA82BB35EE175F02612C@LCHQEX03.lancope.local>
 <FB09F9AF3FE25444B277AA82BB35EE175F028482@LCHQEX03.lancope.local>
 <20120329165806.GC3147@burratino>
 <FB09F9AF3FE25444B277AA82BB35EE175F0284E2@LCHQEX03.lancope.local>
 <20120329194751.GG3147@burratino>
 <20120609164753.GA18761@burratino>
 <20120624151318.GA18451@burratino>
 <CAHtARFH=kmVO_xWs+DafPuWd+wPFnP-Cw5vTVRR-Pd3+xDxkzw@mail.gmail.com>
 <20120628202743.GA7295@burratino>
 <CAHtARFHafR+hrB4u=wDUSE3-J2uXOQCFHW3wRSQMiebowu-9iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:45741 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758652Ab2J2Lu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2012 07:50:57 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so2397253dak.19
        for <linux-scsi@vger.kernel.org>; Mon, 29 Oct 2012 04:50:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAHtARFHafR+hrB4u=wDUSE3-J2uXOQCFHW3wRSQMiebowu-9iA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, Buford Peek <BPeek@lancope.com>, 666108@bugs.debian.org, Gator_Yin@dell.com, linux-scsi@vger.kernel.org, Priyantha Bleeker <priyantha.bleeker@gmail.com>, Edward Konetzko <konetzed@gmail.com>

Hi,

In June, adam radford wrote:
> On Thu, Jun 28, 2012 at 1:27 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:

>> If someone makes a backport of the patches marked [3] as well, would
>> you be able to look over or test the combination?  That would be much
>> appreciated.  If that's not possible, your advice would still be
>> welcome but we will need to use a more minimal set of changes.
>
> Yes, I will be able to look over and/or test the combination.  If you
> apply all patches then diff vs. the scsi-misc tip, you should only see
> kernel 2.6.32.y specific changes.

Sorry for the long delay.

I've made a backport with all relevant patches I could find from the
3.0.y tree and put the patches and a built package at

  http://alioth.debian.org/~jrnieder-guest/temp/driver-test/

Patches are against 2.6.32.y.  The most notable missing patch is the
BKL conversion --- for Debian squeeze it seems safest to just keep
using the BKL.  I'd be happy for any thoughts you have.

Thanks,
Jonathan
