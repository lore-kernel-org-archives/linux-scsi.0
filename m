From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acceleration
Date: Mon, 15 Dec 2008 16:05:45 +0200
Message-ID: <20081215140545.GQ15052@edu.joroinen.fi>
References: <200812092215.mB9MFMZt015198@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <200812092215.mB9MFMZt015198-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


On Tue, Dec 09, 2008 at 02:15:22PM -0800, Karen Xie wrote:
> 
> [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acceleration 
> 
> From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> 
> Here is the updated patchset for adding cxgb3i iscsi initiator.
> 
> The updated version incorporates the comments from Mike and Boaz:
> - remove the cxgb3 sysfs entry for the private iscsi ip address, it can be
>   accessed from iscsi.
> - in cxgb3i.txt, added error message logged for not setting MaxRecvDataSegmentLength properly.
> - renamed cxgb3i Makefile to Kbuild
> - removed "select ISCSI_TCP" in Kconfig
> - consistent handling of AHS: on tx, reserve rooms for AHS; on rx, assume we could receive AHS.
> - add support of bi-directional commands for ddp setup,
> 
> The cxgb3i driver, especially the part handles the offloaded iscsi tcp connection mangement, has gone through the netdev review (http://marc.info/?l=linux-netdev&m=121944339211552, http://marc.info/?l=linux-netdev&m=121989660016124).
> 
> The cxgb3i driver provides iscsi acceleration (PDU offload and payload data direct placement) to the open-iscsi initiator. It accesses the hardware through the cxgb3 module.
> 

Hello!

Do you guys have performance comparison/numbers for normal open-iscsi over tcp vs. cxgb3i accelerated?

Would be nice to see throughput/iops/cpu-usage statistics..

-- Pasi
