From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [PATCH] use mmiowb in qla1280.c
Date: 22 Oct 2004 05:53:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq03c07nkom.fsf@jaguar.mkp.net>
References: <200410211613.19601.jbarnes@engr.sgi.com>
	<200410211617.14809.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:51872 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S270877AbUJVJxP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 05:53:15 -0400
In-Reply-To: <200410211617.14809.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jeremy@sgi.com

>>>>> "Jesse" == Jesse Barnes <jbarnes@engr.sgi.com> writes:

Jesse> There are a few spots in qla1280.c that don't need a full PCI
Jesse> write flush to the device, but rather a simple write ordering
Jesse> guarantee.  This patch changes some of the PIO reads that cause
Jesse> write flushes into mmiowb calls instead, which is a lighter
Jesse> weight way of ensuring ordering.

Jesse> Jes and James, can you ack this and/or push it in via the SCSI
Jesse> BK tree?

ACK!

James will you push this one?

Cheers,
Jes
