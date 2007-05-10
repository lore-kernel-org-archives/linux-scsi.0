From: Christoph Hellwig <hch@infradead.org>
Subject: Re: use_sg != 0 assumption (was Re: [PATCH 5/9] Drop single buffer
	request support.)
Date: Thu, 10 May 2007 12:44:11 +0100
Message-ID: <20070510114411.GA17971@infradead.org>
References: <11787529952207-git-send-email-krh@redhat.com>
	<11787530023454-git-send-email-krh@redhat.com>
	<11787530031570-git-send-email-krh@redhat.com>
	<11787530031450-git-send-email-krh@redhat.com>
	<11787530043878-git-send-email-krh@redhat.com>
	<4642F627.5040400@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <4642F627.5040400@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kristian H?gsberg <krh@redhat.com>, linux1394-devel <linux1394-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 10, 2007 at 12:38:31PM +0200, Stefan Richter wrote:
> >  	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof orb->request);
> >  
> 
> Would a BUG_ON(cmd->use_sg == 0); be in order?

I don't think we should put this into every driver.  If you want to
be sure this doesn't happen anymore put it just in front of the queuecommand
call.

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
