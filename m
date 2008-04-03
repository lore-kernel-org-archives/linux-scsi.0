From: "Sabuj Pattanayek" <sabujp@gmail.com>
Subject: Re: kernel exception in Fusion MPT base driver 3.04.06 (linux-2.6.24.3)
Date: Wed, 2 Apr 2008 19:02:51 -0500
Message-ID: <e64671580804021702n3e9a3a44v7042029c45d38806@mail.gmail.com>
References: <e64671580803171629g534ebf34l89adbb14bb985dc7@mail.gmail.com>
	 <20080318002502.852d0f12.akpm@linux-foundation.org>
	 <47DFFE90.8050808@sgi.com>
	 <e64671580803191411r7ca57fffu885e173f9b3285d0@mail.gmail.com>
	 <e64671580803191636r59d0cd0ar93692dc50d852be7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:16257 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbYDCACw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 20:02:52 -0400
Received: by rn-out-0910.google.com with SMTP id e24so1921814rng.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Apr 2008 17:02:51 -0700 (PDT)
In-Reply-To: <e64671580803191636r59d0cd0ar93692dc50d852be7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

Hi all,

On Wed, Mar 19, 2008 at 6:36 PM, Sabuj Pattanayek <sabujp@gmail.com> wrote:
> Hi,
>  >  >  Does the exception happen every time?
>

After going through lots of hardware (HBAs, motherboards, PSUs) it was
determined that there was a problem with the PCI-X riser in this
particular system. Sorry about the false alarm but this one was
difficult to track down.

Thanks,
Sabuj
