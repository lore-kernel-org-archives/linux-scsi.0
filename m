From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH v2 0/7] ibmvscsi code cleanup
Date: Wed, 10 Feb 2016 19:32:21 -0600
Message-ID: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de, manoj@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Fixed up a couple spots that were out of line with the PAPR in regards
to its defined VSCSI protocol. Did away with some magic numbers directly
in the code. Fixed a minor endian issue.
