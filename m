From: Grant Grundler <grundler@google.com>
Subject: Re: Question regarding SAS controllers.
Date: Mon, 24 Nov 2008 08:11:05 -0800
Message-ID: <da824cf30811240811l416431f5kf56e0925f561342@mail.gmail.com>
References: <alpine.DEB.1.10.0811221645250.707@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753840AbYKXQLW@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811221645250.707@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 22, 2008 at 1:46 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Do any SAS controllers exist that are not RAID?
>
> Or to put it another way, if one wants to use SAS disks for example and NOT
> export them as JBOD or use them as RAID, is there a normal controller?

Besides mptsas, there is mvsas (Marvell 6480 chip , IIRC).

> Back in the days of regular SCSI you had SCSI controllers and SCSI raid
> controllers, when searching for SAS controllers now, all that comes up is
> hundreds of SAS-Raid controllers.

Because lots of the windows server users demand HW RAID?
And it's a "value add"; vendors can charge more money for the RAID cards.

grant
