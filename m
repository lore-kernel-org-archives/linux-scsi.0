From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fnic: remove a pointless test
Date: Mon, 14 Nov 2016 18:48:59 -0500
Message-ID: <yq1shqtei6s.fsf@sermon.lab.mkp.net>
References: <1478018421-22820-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24328 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964958AbcKNXtH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 18:49:07 -0500
In-Reply-To: <1478018421-22820-1-git-send-email-thenzl@redhat.com> (Tomas
        Henzl's message of "Tue, 1 Nov 2016 17:40:21 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, sramars@cisco.com, hiralpat@cisco.com, buchino@cisco.com

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

Tomas> rport can't be null here, it would have failed already in
Tomas> fc_remote_port_chkready

Cisco folks: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
