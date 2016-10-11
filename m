From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/23] scsi_dh_alua: Add new blacklist flag
 'BLIST_SYNC_ALUA'
Date: Tue, 11 Oct 2016 08:00:33 +0200
Message-ID: <370deeee-d98a-12cc-8efa-5a4ee5037282@suse.de>
References: <9c10ea3c-76e5-8aad-4b30-1fd34d9bf288@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbcJKGAg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 02:00:36 -0400
In-Reply-To: <9c10ea3c-76e5-8aad-4b30-1fd34d9bf288@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, "Stewart, Sean" <Sean.Stewart@netapp.com>, "George, Martin" <Martin.George@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>, "Schremmer, Steven" <Steven.Schremmer@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 10/10/2016 11:24 PM, Xose Vazquez Perez wrote:
> Hi Hannes,
> 
> Try #2.
> Is this needed for RDAC(INF-01-00) devices?
> 
Actually I have been in contact with NetApp, and they prefer _not_ to
have the RDAC arrays marked for synchronous ALUA. They have validated
things on their current firmware and the synchronous ALUA setting is not
required anymore.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
