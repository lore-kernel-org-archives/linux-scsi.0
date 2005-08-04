From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/3] cpqarray: ioctl support to configure LUNs
	dynamically
Date: Thu, 04 Aug 2005 10:18:43 +0200
Message-ID: <1123143523.3318.7.camel@laptopd505.fenrus.org>
References: <4221C1B21C20854291E185D1243EA8F302623BD9@bgeexc04.asiapacific.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:64718 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262255AbVHDITk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 04:19:40 -0400
In-Reply-To: <4221C1B21C20854291E185D1243EA8F302623BD9@bgeexc04.asiapacific.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saripalli, Venkata Ramanamurthy (STSD)" <saripalli@hp.com>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2005-08-04 at 10:15 +0530, Saripalli, Venkata Ramanamurthy
(STSD) wrote:
> Patch 2 of 3
> This patch adds support for IDAREGNEWDISK, IDADEREGDISK, IDAGETLOGINFO
> ioctls required
> to configure LUNs dynamically on SA4200 controller using ACU.


I don't think it's a good idea to add new ioctls to drivers like this...


