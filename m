From: linas <linas@austin.ibm.com>
Subject: Re: [PATCH 1/1] scsi: scsi inquiry timeout config option
Date: Mon, 3 Oct 2005 15:39:24 -0500
Message-ID: <20051003203924.GS29826@austin.ibm.com>
References: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc64-dev-bounces@ozlabs.org>
Content-Disposition: inline
In-Reply-To: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc64-dev>
List-Post: <mailto:linuxppc64-dev@ozlabs.org>
List-Help: <mailto:linuxppc64-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc64-dev>,
	<mailto:linuxppc64-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc64-dev-bounces@ozlabs.org
Errors-To: linuxppc64-dev-bounces@ozlabs.org
To: brking@us.ibm.com
Cc: James.Bottomley@steeleye.com, linuxppc64-dev@ozlabs.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 03, 2005 at 03:26:30PM -0500, brking@us.ibm.com was heard to remark:
> 
> Add a .config option to default the scsi scan inquiry timeout.
> Due to a broken device (SCSI/ATA converter card) that is very
> common on IBM iSeries/pSeries machines, these architectures
> need a longer default inquiry timeout.

Hmm, I thought I fixed this several yeas ago. I guess it didn't 
stay fixed? 

--linas
