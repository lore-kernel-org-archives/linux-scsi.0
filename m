From: David.Egolf@Bull.com
Subject: Re: [(re)Announce] Emulex LightPulse Device Driver
Date: Thu, 13 May 2004 14:21:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <OF43CA8574.3A9C651D-ON07256E93.00714C91-07256E93.0075513F@az05.bull.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org-S265113AbUEMVVj@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@infradead.org>
Sent by: linux-scsi-owner@vger.kernel.org
05/09/2004 01:20 AM

>A bunch of comments from looking over the headers and itnerface to
>upper layers a little:  (next I'll try to understand what's going on
>in the I/O submission path - it's just to freakin complicated..):
>
> - the hba api crap must die
> o o o

The first bullet on your post is of interest to us.  We currently support 
customers with Emulex fc cards using a 2.4 kernel on IA64.  Our software 
employs the hba api supplied from Emulex in order determine the 
configuration of the SAN(s) connected to the cards.

Your comment is on the terse side.  Is your comment directed at this 
particular implementation of the hba api code, the current packaging 
situation, or do you have a general disregard for the hba api strategy? In 
short, do you believe that the hba api can and/or should be supported for 
the Emulex LightPulse Device Driver? 

-- David Egolf
