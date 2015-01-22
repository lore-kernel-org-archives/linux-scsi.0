From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: sc_data_direction and bidi commands
Date: Thu, 22 Jan 2015 02:02:54 -0800
Message-ID: <1421920974.7061.55.camel@haakon3.risingtidesystems.com>
References: <54BFD163.4020802@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54927 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbbAVKCz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2015 05:02:55 -0500
In-Reply-To: <54BFD163.4020802@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2015-01-21 at 17:18 +0100, Bart Van Assche wrote:
> Hello,
> 
> Although several SCSI LLDs compare sc_data_direction with the value
> DMA_BIDIRECTIONAL apparently scsi_setup_cmnd() never sets
> sc_data_direction to the value DMA_BIDIRECTIONAL. Is this behavior on
> purpose ?
> 

Yes.  Bi-directional CDBs are signaled using scsi_bidi_cmnd(), and IIRC
->sc_data_direction = DMA_TO_DEVICE is set for those cases.

There is an example in drivers/target/loopback/tcm_loop.c, btw.

--nab





