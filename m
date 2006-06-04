From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: scsi layer differences between 2.4 and 2.6
Date: Sun, 04 Jun 2006 19:42:23 +0200
Message-ID: <1149442944.3109.124.camel@laptopd505.fenrus.org>
References: <20060604173132.30735.qmail@web30312.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50350 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750817AbWFDRm0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jun 2006 13:42:26 -0400
In-Reply-To: <20060604173132.30735.qmail@web30312.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Cullen <timcullen2001@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2006-06-04 at 10:31 -0700, Tim Cullen wrote:
> What is happening is that read and write performance
> are lower on a 2.6 (SLES9 SP2) based kernel than on a
> 2.4 based kernel.
> 
> The test hardware is a Cray XT3 connected to a DDN
> S2A8500 RAID array. The test is sequential reads and
> writes from programs like sgp_dd and ior.

what is the HBA in use? (eg which driver?)


