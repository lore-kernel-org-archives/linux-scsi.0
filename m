From: Christoph Hellwig <hch@infradead.org>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Mon, 26 Aug 2013 02:05:40 -0700
Message-ID: <20130826090540.GA26892@infradead.org>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
 <yq1zjskgn1x.fsf@sermon.lab.mkp.net>
 <D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com>
 <yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
 <FE68512D-F375-456B-948A-492634A02F0F@servergy.com>
 <yq1haeqcuce.fsf@sermon.lab.mkp.net>
 <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com>
 <3DA40821-A3AC-45CA-BD22-995EA256837A@servergy.com>
 <088E451FE1854947BD9145EF8C016FF413A017BC30@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3HZJFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 05:05:50 -0400
Content-Disposition: inline
In-Reply-To: <088E451FE1854947BD9145EF8C016FF413A017BC30@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Cc: Ben Collins <ben.c@servergy.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>, "Maloy, Joe" <Joe.Maloy@lsi.com>

On Mon, Aug 26, 2013 at 12:51:07PM +0530, Saxena, Sumit wrote:
> We are conferring with Marketing and Product Management on direction  wrt  Big endian support for megaraid_sas driver.  Our goal is to gain clear direction within two weeks.

Sorry guys, but this is just utter bullshit.  There are obviously
correct patches out that make an important class of controllers work
with no downside at all given that code doesn't even change for little
endian compiled driver binaries.

I have to say I'm a little sad and disappointed we're even arguing this
in any form and that patch haven't been merged long ago.

