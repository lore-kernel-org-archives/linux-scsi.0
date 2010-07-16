From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
Subject: Re: mvsas still has problems with 2.6.34
Date: Fri, 16 Jul 2010 00:53:01 -0600
Message-ID: <201007160053.01673.tfjellstrom@strangesoft.net>
References: <201007160010.58000.tfjellstrom@strangesoft.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201007160010.58000.tfjellstrom@strangesoft.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, ayan@marvell.com, andy yan <andyysj@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On July 16, 2010, Thomas Fjellstrom wrote:
> I've recently updated my server, and the mvsas driver included in
> 2.6.34.1 still causes my AOC-SASLP-MV8 card to completely lock up after
> mdraid starts up on the devices. The machine is essentially in
> "production" so I can't do a heck of a lot of testing on it anymore. The
> mvsas driver I got from Andy Yan seems to be a little outdated, it fails
> to compile due to a missing argument to sas_change_queue_depth, which I
> managed to fix, and I will try testing. I hope it works.

It seems to work with the change I made. 

> At some point though I really hope this gets fixed. I'm still willing to
> help test any new versions, just that I can't keep my box down for an
> extended period.
> 
> Thanks.


-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
