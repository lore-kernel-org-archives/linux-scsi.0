From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] Add struct crypto_alg->cra_check_optimized for crc32c_intel
Date: Thu, 10 Mar 2011 00:21:10 -0800
Message-ID: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Herbert and Co,

This series adds a struct crypto_alg->cra_check_optimized() that can be optionally
used by crc32c.ko (and other algorithms) in order to make a request_module() call
to load architecture dependent offload code for a libcrypto base algorithm.

This patch is a result of feedback during review for the iscsi_target_mod fabric
module here:

Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
http://marc.info/?l=linux-scsi&m=129974455726437&w=2

Please review and comment,

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  crypto: Add struct crypto_alg->cra_check_optimized
  crypto/crc32c: Add crc32c_cra_check_optimized for crc32c_intel

 crypto/api.c           |    6 +++++-
 crypto/crc32c.c        |   23 +++++++++++++++++++++++
 include/linux/crypto.h |    1 +
 3 files changed, 29 insertions(+), 1 deletions(-)
