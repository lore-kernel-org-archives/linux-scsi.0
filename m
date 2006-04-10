From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] deinline some functions in aic7xxx drivers, save 80k
 of text
Date: Mon, 10 Apr 2006 12:16:29 +0200
Message-ID: <443A307D.4060102@s5r6.in-berlin.de>
References: <200604100844.12151.vda@ilport.com.ua> <200604100903.35431.eike-kernel@sf-tec.de> <200604101015.36869.vda@ilport.com.ua> <200604100919.23244.eike-kernel@sf-tec.de> <443A2805.6000806@s5r6.in-berlin.de> <443A2CDB.5060404@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751123AbWDJKRg@vger.kernel.org>
In-Reply-To: <443A2CDB.5060404@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Denis Vlasenko <vda@ilport.com.ua>, SCSI List <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, gibbs@scsiguy.com
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Re multiplatform development: aic7{9,x}xx have ceased to be
> multiplatfrom since the integration of scsi_transport_spi.
> So I wouldn't worry too much about it.

Then it may be possible to save even more than 80k of text.
-- 
Stefan Richter
-=====-=-==- -=-- -=-=-
http://arcgraph.de/sr/
