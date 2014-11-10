From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Discard update for 3.19
Date: Mon, 10 Nov 2014 06:19:06 -0800
Message-ID: <20141110141906.GA20891@infradead.org>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de
List-Id: linux-scsi@vger.kernel.org

Looks like there is no real dependency between these patches, so we
might take on each through the libata, scsi and block trees.

Can I get another review for the sd patch, please?

