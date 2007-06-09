From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/7] scsi-hw-handler: convert dm-mpath to
	scsi hw handlers
Date: Sat, 09 Jun 2007 14:18:26 -0500
Message-ID: <466AFD02.30403@cs.wisc.edu>
References: <11814160842916-git-send-email-michaelc@cs.wisc.edu>
	<11814160853812-git-send-email-michaelc@cs.wisc.edu>
	<1181416085774-git-send-email-michaelc@cs.wisc.edu>
	<11814160863051-git-send-email-michaelc@cs.wisc.edu>
	<11814160871580-git-send-email-michaelc@cs.wisc.edu>
	<11814160881707-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11814160881707-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: michaelc@cs.wisc.edu
Cc: dm-devel@redhat.com, Alasdair Graeme Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patch converts dm-mpath to scsi hw handlers. It does
> not add any new functionality and old behaviors and userspace
> tools should be supported except we use the safe clariion
> default instead of using the userspace setting.
> 
> This is just the dm-mpath parts which are necessary to use
> REQ_TYPE_LINUX_BLOCK and REQ_LB_OP_TRANSITION. In later mails
> I will send patches which remove old code and add more
> functionality.
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Alasdair, I took out all the new functionality. This patch is just the
basic conversion. I can try to break it down even more if and do a patch
for every hw handler callout that gets removed (all the callouts end up
getting removed), but that may not buy much since the bulk of the patch
is the REQ_TYPE_LINUX_BLOCK code.
