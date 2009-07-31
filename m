From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Understanding SAS
Date: Fri, 31 Jul 2009 09:26:45 -0500
Message-ID: <1249050405.3922.11.camel@mulgrave.site>
References: <e79524560907310456x7b2cf0c0h7e0453ceb55982fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36503 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbZGaO0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 10:26:49 -0400
In-Reply-To: <e79524560907310456x7b2cf0c0h7e0453ceb55982fd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhukar G <madhukar.linux@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-07-31 at 17:26 +0530, Madhukar G wrote:
> I'm understanding SAS architecture for adaptec controller. I'm using
> the source adp94xx for the same. I was able to understand all the
> infomation unit flow but i'm stuck with one problem. I was not able to
> trace when task management IU shall be invoked.
> Do i need any special app to test task management IU?
> Is SCSI layer responsible for invoking task management IU?

I don't understand what you mean by IU:  SAS tends to think in terms of
frames (at the transport layer).  Information Units as used by the SAS
protocol means specific SSP frames.  Task Management in SAS has to
include SMP, STP and SATA as well.

However, SAM task management functions all map to the callbacks in
struct sas_domain_function_template which are called by libsas.  These
callbacks are also used for all other frame error handling.

James


