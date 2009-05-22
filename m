From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/24] mpt fusion: [2.6.30-rc6] small fix for 1078 data
	corruption issue
Date: Fri, 22 May 2009 09:27:03 -0500
Message-ID: <1243002423.2873.2.camel@localhost.localdomain>
References: <20090522104130.GF16245@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55915 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbZEVO1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2009 10:27:04 -0400
In-Reply-To: <20090522104130.GF16245@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:11 +0530, Kashyap, Desai wrote:
> Patch applied on 21/01/2009: "Fixing 1078 data curruption" need this changes
> also.
> message flags will use runtime sense width instead of compile time as
> explain in patch applied on 21/01/2009 "Fixing 1078 data curruption".

This description doesn't make a whole lot of sense, since patch "Fixing
1078 data corruption" is 1/24 of this series ... I take it these two
patches should be merged?

James


