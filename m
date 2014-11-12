From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] Discard update for 3.19
Date: Wed, 12 Nov 2014 14:41:53 -0500
Message-ID: <yq1mw7wyzni.fsf@sermon.lab.mkp.net>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	<20141110141906.GA20891@infradead.org>
	<1415817615.16672.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41366 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKLTm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 14:42:29 -0500
In-Reply-To: <1415817615.16672.49.camel@localhost.localdomain> (Ewan Milne's
	message of "Wed, 12 Nov 2014 13:40:15 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de

>>>>> "Ewan" == Ewan Milne <emilne@redhat.com> writes:

Ewan> The changes in [PATCH 2/3] sd: Disable discard_zeroes_data for
Ewan> UNMAP look fine to me.  I was wondering, though, if the changes to
Ewan> add the "devices_handle_discard_safely" module parameter to the MD
Ewan> raid drivers are really needed if this is fixed.

I was expecting Neil to either revert or toggle the default once this
change was in place.

-- 
Martin K. Petersen	Oracle Linux Engineering
