From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: add new RDAC LENOVO/DE_Series device
Date: Wed, 03 Apr 2019 23:29:07 -0400
Message-ID: <yq1d0m2tpmk.fsf@oracle.com>
References: <20190330144331.20276-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190330144331.20276-1-xose.vazquez@gmail.com> (Xose Vazquez
	Perez's message of "Sat, 30 Mar 2019 15:43:31 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, DM ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: linux-scsi@vger.kernel.org


Xose,

> Blacklist "Universal Xport" LUN, it's used for in-band storage array
> management.  And add it to the rdac dh family.

Applied to 5.1/scsi-fixes, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
