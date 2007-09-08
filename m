From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sat, 08 Sep 2007 21:32:08 +0200
Message-ID: <46E2F8B8.5020003@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <20070908095008.08eb4930.randy.dunlap@oracle.com> <20070908181309.GA8647@one.firstfloor.org> <46E2EA2E.6020002@s5r6.in-berlin.de> <20070908191457.GB8647@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755157AbXIHTdZ@vger.kernel.org>
In-Reply-To: <20070908191457.GB8647@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andi Kleen wrote:
> On Sat, Sep 08, 2007 at 08:30:06PM +0200, Stefan Richter wrote:
>> Andi Kleen wrote:
>>> when you've been using CONFIG_IDE before it is not completely
>>> obvious you need BLK_SD for your hard disk.
>> Switching to different drivers without reading the help text?
>> Tough.
> 
> The individual driver descriptions don't say BLK_SD needs to be selected.

At least the help to CONFIG_ATA says so.

> Besides if all descriptions said that

We certainly don't want (too much) redundancy in help texts.

> the computer could as well
> do it for the user automatically. After all it's a stupid repetive
> task and computers are much better at those than humans.

In your patch, it is not the computer who finds out that the user wants
BLK_SD.  It is you who predetermined that the user wants it.
-- 
Stefan Richter
-=====-=-=== =--= -=---
http://arcgraph.de/sr/
