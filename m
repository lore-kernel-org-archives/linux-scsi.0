Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7938C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 18:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6049208E4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 18:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgGTSb1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 14:31:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgGTSb0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 14:31:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxaZF-0063w5-Tx; Mon, 20 Jul 2020 20:31:13 +0200
Date:   Mon, 20 Jul 2020 20:31:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alobakin@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-everest-linux-l2@marvell.com,
        QLogic-Storage-Upstream@marvell.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 01/16] linkmode: introduce
 linkmode_intersects()
Message-ID: <20200720183113.GK1339445@lunn.ch>
References: <20200720180815.107-1-alobakin@marvell.com>
 <20200720180815.107-2-alobakin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720180815.107-2-alobakin@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 09:08:00PM +0300, Alexander Lobakin wrote:
> Add a new helper to find intersections between Ethtool link modes,
> linkmode_intersects(), similar to the other linkmode helpers.
> 
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
