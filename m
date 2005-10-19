From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/12]  qla2xxx: Add support for embedded ISP24xx firmware.
Date: Wed, 19 Oct 2005 17:19:30 +0100
Message-ID: <20051019161929.GA3862@infradead.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231624.27191.96727.sendpatchset@plap.qlogic.com> <20051014094717.GA22347@infradead.org> <20051014165035.GB19098@plap.qlogic.org> <20051015115801.GB24919@infradead.org> <20051017213405.GG9192@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:27015 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750838AbVJSQTc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 12:19:32 -0400
Content-Disposition: inline
In-Reply-To: <20051017213405.GG9192@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Oct 17, 2005 at 02:34:05PM -0700, Andrew Vasquez wrote:
> Ok, so what's going to be the policy regarding firmware updates:

Updates for existing drivers are fine mid-term, just please avoid adding new
ones.
