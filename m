From: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch] 2.6 -- add IOI Media Bay to SCSI quirk list
Date: Thu, 12 Aug 2004 19:00:53 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <411BF6A5.2030306@tuxdriver.com>
References: <200408122137.i7CLbGU13688@ra.tuxdriver.com> <20040812225118.GA20904@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S268864AbUHLXB4@vger.kernel.org>
In-Reply-To: <20040812225118.GA20904@beaverton.ibm.com>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
List-Id: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:

>We seem to be getting quite a few of these. In theory we could add a line
>like this for every multi-lun SCSI device.
>  
>

Isn't that what the quirk list is for?

>Can you instead try booting with scsi_mod.max_luns=8 (or such) or build
>with SCSI_MULTI_LUN enabled?
>  
>

That works for my box, but what about for others?  Like those who may 
have both a multi-lun device and a single-lun device that hangs on a 
non-zero lun?  What about the average luser who can't be bothered to 
hack-up his startup scripts or *gasp* rebuild his kernel?

It seems like the quirk list is there for a reason.  If we start 
rejecting certain devices, then what is the criteria for a device to 
actually make it on the list?

John
