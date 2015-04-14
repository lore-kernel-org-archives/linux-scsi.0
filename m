From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 02/15] target: Add protected fabric + unprotected device support
Date: Mon, 13 Apr 2015 21:15:14 -0400
Message-ID: <yq1bnir7bod.fsf@sermon.lab.mkp.net>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	<1427686104-14231-3-git-send-email-nab@daterainc.com>
	<yq1sicbh63q.fsf@sermon.lab.mkp.net>
	<1428478828.18203.109.camel@haakon3.risingtidesystems.com>
	<yq18ue1f02d.fsf@sermon.lab.mkp.net>
	<1428692341.20502.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428692341.20502.17.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Fri, 10 Apr 2015 11:59:01 -0700")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> The following incremental patch saves the current sess_prot_type
nab> into se_node_acl, and will always reset sess_prot_type if a
nab> previous saved value exists.  So the PI setting for the fabric's
nab> session with backend devices not supporting PI is persistent across
nab> session restart.

nab> I also noticed the internal DIF emulation was not honoring se_cmd->
nab> prot_checks for the WRPROTECT/RDPROTECT == 0x3 case, so
nab> sbc_dif_v1_verify() has been updated to follow which checks have
nab> been calculated based on WRPROTECT/RDPROTECT in
nab> sbc_set_prot_op_checks().

nab> Finally in sbc_check_prot(), if PROTECT is non-zero for a backend
nab> device with DIF disabled, and sess_prot_type is not set go ahead
nab> and return INVALID_CDB_FIELD.

Looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
