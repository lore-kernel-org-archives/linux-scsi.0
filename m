From: Joe Eykholt <fcoe@eykholt.com>
Subject: Re: [OpenFCoE PATCH] If expecting pre-T11 frames, a T11 frame	caused
 a data fault.
Date: Wed, 05 Dec 2007 08:42:01 -0800
Message-ID: <4756D4D9.70608@eykholt.com>
References: <20071205005214.26211.62814.stgit@mink.he.net> <20071205135543.GA2174@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:46824 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751716AbXLEQlw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Dec 2007 11:41:52 -0500
Received: from 67.91.200.194 ([67.91.200.194]) by eykholt.com for <linux-scsi@vger.kernel.org>; Wed, 5 Dec 2007 08:41:50 -0800
In-Reply-To: <20071205135543.GA2174@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Just wondering:
> 
>>From my quick reading of the code these pre-T11 frames are basically
> a different frame-level protocol.  Given that T11 has standardized
> on a different one what's the rationale for supporting the old frames?

There is still some use in lab environments of the old frame format, and
it would greatly help if we could keep it working for now.  Eventually,
in a year or so, it could be removed completely.  It seems to be a small
amount of code and in a loadable module besides.

	Joe
