From: Ric Wheeler <rwheeler@redhat.com>
Subject: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 09:26:49 -0500
Message-ID: <49145029.4040900@redhat.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50958 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbYKGO1e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2008 09:27:34 -0500
In-Reply-To: <20081107121934.GP21867@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>


One more consideration that I should have mentioned is that we can also 
make our file system allocation policies "thin provisioned LUN" friendly.

Basically, we need to try to re-allocate blocks instead of letting the 
allocations happily progress across the entire block range. This might 
be the inverse of an SSD friendly allocation policy, but would seem to 
be fairly trivial to implement :-)

ric

