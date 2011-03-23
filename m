From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
 initial merge
Date: Wed, 23 Mar 2011 17:54:51 +0900
Message-ID: <20110323175451J.fujita.tomonori@lab.ntt.co.jp>
References: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:56122 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab1CWJCs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 05:02:48 -0400
In-Reply-To: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com

I've not looked at the code yet but...

On Tue, 22 Mar 2011 20:06:31 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> Nicholas Bellinger (14):
>   iscsi: Resolve iscsi_proto.h naming conflicts with
>     drivers/target/iscsi
>   iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
>   target: Convert REPORT_LUNs to use int_to_scsilun
>   iscsi-target: Add iSCSI fabric support for target v4
>   iscsi-target: Add TCM v4 compatiable ConfigFS control plane
>   iscsi-target: Add configfs fabric dependent statistics
>   iscsi-target: Add TPG and Device logic
>   iscsi-target: Add iSCSI Login Negotiation and Parameter logic
>   iscsi-target: Add CHAP Authentication support using libcrypto
>   iscsi-target: Add Sequence/PDU list + DataIN response logic
>   iscsi-target: Add iSCSI Error Recovery Hierarchy support
>   iscsi-target: Add support for task management operations
>   iscsi-target: Add misc utility and debug logic
>   iscsi-target: Add Makefile/Kconfig and update TCM top level
> 
>  drivers/infiniband/ulp/iser/iser_initiator.c      |    2 +-
>  drivers/scsi/be2iscsi/be_main.h                   |    4 +-
>  drivers/scsi/bnx2i/bnx2i_hwi.c                    |    8 +-
>  drivers/scsi/bnx2i/bnx2i_iscsi.c                  |    2 +-
>  drivers/scsi/libiscsi.c                           |   22 +-
>  drivers/target/Kconfig                            |    2 +
>  drivers/target/Makefile                           |    3 +
>  drivers/target/iscsi/Kconfig                      |   17 +
>  drivers/target/iscsi/Makefile                     |   20 +
>  drivers/target/iscsi/iscsi_target.c               | 5017 +++++++++++++++++++++
>  drivers/target/iscsi/iscsi_target.h               |   32 +
>  drivers/target/iscsi/iscsi_target_auth.c          |  496 ++
>  drivers/target/iscsi/iscsi_target_auth.h          |   32 +
>  drivers/target/iscsi/iscsi_target_configfs.c      | 1914 ++++++++
>  drivers/target/iscsi/iscsi_target_configfs.h      |    7 +
>  drivers/target/iscsi/iscsi_target_core.h          |  881 ++++
>  drivers/target/iscsi/iscsi_target_datain_values.c |  531 +++
>  drivers/target/iscsi/iscsi_target_datain_values.h |   15 +
>  drivers/target/iscsi/iscsi_target_debug.h         |  113 +
>  drivers/target/iscsi/iscsi_target_device.c        |  108 +
>  drivers/target/iscsi/iscsi_target_device.h        |    9 +
>  drivers/target/iscsi/iscsi_target_erl0.c          | 1005 +++++
>  drivers/target/iscsi/iscsi_target_erl0.h          |   17 +
>  drivers/target/iscsi/iscsi_target_erl1.c          | 1305 ++++++
>  drivers/target/iscsi/iscsi_target_erl1.h          |   28 +
>  drivers/target/iscsi/iscsi_target_erl2.c          |  483 ++
>  drivers/target/iscsi/iscsi_target_erl2.h          |   18 +
>  drivers/target/iscsi/iscsi_target_login.c         | 1245 +++++
>  drivers/target/iscsi/iscsi_target_login.h         |   13 +
>  drivers/target/iscsi/iscsi_target_nego.c          | 1068 +++++
>  drivers/target/iscsi/iscsi_target_nego.h          |   19 +

Why do we need to do the pre-nexus operations such as login,
authentication, negotiation, etc in kernel?

