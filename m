From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] scsi_dh_alua: remove synchronous STPG support
Date: Wed, 21 Jun 2017 18:41:32 +0000
Message-ID: <1498070490.2746.22.camel@wdc.com>
References: <20170619122724.32720-1-hch@lst.de>
         <20170619122724.32720-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:35583 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFUSle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2017 14:41:34 -0400
In-Reply-To: <20170619122724.32720-2-hch@lst.de>
Content-Language: en-US
Content-ID: <D782003005802749AD9D823554DCC634@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hare@suse.de" <hare@suse.de>

On Mon, 2017-06-19 at 14:27 +0200, Christoph Hellwig wrote:
> Since 9c58b395 ("scsi: scsi_devinfo: remove synchronous ALUA for
> NETAPP devices") this code is unused.

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>=
