From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Tue, 10 Jul 2012 02:21:09 +0200
Message-ID: <4FFB7575.4060603@matthiasprager.de>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <4FFB32E5.1050109@farcaster.org> <20120709204513.GD25664@kernel.stglabs.ibm.com> <4FFB5A0F.30400@farcaster.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FFB5A0F.30400@farcaster.org>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Trace <maillist@farcaster.org>
Cc: djwong@us.ibm.com, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, Matthias Prager <linux@matthiasprager.de>
List-Id: linux-scsi@vger.kernel.org

Am 10.07.2012 00:24, schrieb Robert Trace:
> 
> Also, TURs don't appear to actually wake the disk up (should they?).
> The only thing I've found that'll wake the disk up is an explicit START
> UNIT command.

I haven't checked the scsi logging side, but about the only commands
that wake up the disks are 'smartctl -a /dev/sda' and 'sg_start'
(smartcl maybe issuing a START UNIT command on it's own).

Matthias
