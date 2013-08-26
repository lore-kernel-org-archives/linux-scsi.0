From: Christoph Hellwig <hch@infradead.org>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Mon, 26 Aug 2013 13:43:19 -0700
Message-ID: <20130826204319.GB26624@infradead.org>
References: <D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com>
 <yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
 <FE68512D-F375-456B-948A-492634A02F0F@servergy.com>
 <yq1haeqcuce.fsf@sermon.lab.mkp.net>
 <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
 <3DA40821-A3AC-45CA-BD22-995EA256837A@servergy.com>
 <088E451FE1854947BD9145EF8C016FF413A017BC30@inbmail01.lsi.com>
 <20130826090540.GA26892@infradead.org>
 <EB4C61A1A2501842A04B573FE42B14D6029EDD85EC@cosmail02.lsi.com>
 <AA2AC8A7-DD06-4AC5-9E4D-E522F6AC1B09@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3HZUn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 16:43:26 -0400
Content-Disposition: inline
In-Reply-To: <AA2AC8A7-DD06-4AC5-9E4D-E522F6AC1B09@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@ubuntu.com>
Cc: "Maloy, Joe" <Joe.Maloy@lsi.com>, Christoph Hellwig <hch@infradead.org>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>, "Maly, JoLyn" <JoLyn.Maly@lsi.com>

On Mon, Aug 26, 2013 at 04:26:30PM -0400, Ben Collins wrote:
> Historically, waiting on commercial upstream to deliver what the community has already done is wasted time. Likewise, historically, allowing patches that partially implement things (in this respect, support one generation of card for megaraid_sas) leads to further support from the community, in a much faster timefram

*nod*  Also historically ignoring hardware vendor mangement chains has
always lead to better drivers.  Not saying that some vendors don't have
competent engineer (many do, mand don't), but as soon as management gets
involved in decisions about drivers all hope is lost.

