From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] configfs: Fix race between create_link and
        configfs_rmdir
Date: Thu, 8 Jun 2017 09:21:29 +0200
Message-ID: <20170608072129.GA13433@lst.de>
References: <1496897514-20142-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496897514-20142-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>
List-Id: linux-scsi@vger.kernel.org

Thanks Nic,

applied to the configfs-for-next tree.  I'm not entirely sure if we
should bother adding this to 4.12 or if it hits rarely enough?
