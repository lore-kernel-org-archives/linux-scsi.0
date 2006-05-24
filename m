From: "Dan Carpenter" <error27@gmail.com>
Subject: Re: mptspi doesn't work the nStor
Date: Tue, 23 May 2006 23:46:15 -0700
Message-ID: <a63d67fe0605232346p73d66be7jc0d717604e894ff6@mail.gmail.com>
References: <a63d67fe0605221637i231d4b48n942461ccdf4ee470@mail.gmail.com>
	 <008901c67e1f$654674c0$321015ac@ericmoore>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.197]:45847 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S932623AbWEXGqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2006 02:46:16 -0400
Received: by nz-out-0102.google.com with SMTP id 8so1749995nzo
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2006 23:46:16 -0700 (PDT)
In-Reply-To: <008901c67e1f$654674c0$321015ac@ericmoore>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, mpt_linux_developer@lsil.com, coldwell@redhat.com

On 5/22/06, Moore, Eric <Eric.Moore@lsil.com> wrote:
> On Monday, May 22, 2006 5:37 PM, Dan Carpenter wrote:
> >I can't get mptspi to work with my nStor in FC5.

> > Fedora Core 5 bugzilla
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=188487
> > RHEL 4u3 buzilla
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=190760
> >
>
> Ok, I see various things here, such as the end device being busy, and data underruns,
> and device not there.  Nothing conclusive.  Can you send me your pariticular dmesg
> with debuging enabled in the driver.  Also in private email I will send you our latest drivers.
>
> Eric Moore

The new drivers don't fix it I'm afraid.

I've attached my dmesg with debugging enabled...  The dumb thing is
that I'm using fusion for the onboard drives so the debugging messages
from the nstor get mixed in with the (working) onboard drives.  Sorry
about that, I'll load a different system tomorrow and send that.

regards,
dan carpenter
