From: Lionel Elie Mamane <lionel@mamane.lu>
Subject: Re: PROBLEM: Linux 2.4.19 + aic7xxx driver = crash
Date: Thu, 10 Oct 2002 08:01:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021010060125.GA10453@home.mamane.lu>
References: <20021009133617.GA18381@home.mamane.lu> <20021009202233.2fb23461.Scsi@PragmaSoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021009202233.2fb23461.Scsi@PragmaSoft.com>
List-Id: linux-scsi@vger.kernel.org
To: Scott Merritt <Scsi@PragmaSoft.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 09, 2002 at 08:22:33PM -0400, Scott Merritt wrote:
> On Wed, 9 Oct 2002 15:36:17 +0200
> Lionel Elie Mamane <lionel@mamane.lu> wrote:

>> [1.] One line summary of the problem:

>>      Linux 2.4.19 + aic7xxx driver = crash

> Just out of curiousity, do you know if Low Latency Dispatching was
> enabled when the Kernel was compiled ?

I don't remember seeing any option like that in the "make
menuconfig". I grepped the .config file for "LAT" and "DIS", no result
that remotely looked like that.

Maybe you are talking about the low latency / interruptible kernel
patches, that thus are *not* part of vanilla 2.4.19? Then, definitely
no, I didn't apply any patch myself. The only difference with the
official 2.4.19 is what the Debian maintainer did, and is described at
the end of my report.

-- 
Lionel
