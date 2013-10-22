From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 00/24] treewide: Convert use of typedef ctl_table to
 struct ctl_table
Date: Tue, 22 Oct 2013 16:58:24 -0700
Message-ID: <1382486304.2041.103.camel@joe-AO722>
References: <cover.1382480758.git.joe@perches.com>
	 <52670FF4.8070701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <52670FF4.8070701@gmail.com>
Sender: linux-ia64-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, keyrings@linux-nfs.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-10-22 at 16:53 -0700, David Daney wrote:
> After all this work, why not go ahead and remove the typedef?  That way 
> people won't add more users of this abomination.

Hi David.

The typedef can't be removed until all the uses are gone.

I've sent this before as a single large patch as well as
individual patches.

treewide:	https://lkml.org/lkml/2013/7/22/600
RemoveTypedef:	https://lkml.org/lkml/2013/7/22/603

