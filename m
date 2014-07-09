From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 0/4] SRP initiator patches for kernel 3.17
Date: Wed, 09 Jul 2014 15:55:47 +0200
Message-ID: <53BD49E3.3090903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch series consists of four patches of which three are bug fixes
and one is a performance optimization.

Changes compared with v1:
- Left out the fifth patch since there is no agreement about that
  patch.
- Added "unlikely(...)" around the tests for overflow / underflow flags
  in the SRP_CMD response as proposed by Dave Dillow.

The patches included in this series are:

0001-scsi_transport_srp-Fix-fast_io_fail_tmo-dev_loss_tmo.patch
0002-IB-srp-Fix-deadlock-between-host-removal-and-multipa.patch
0003-IB-srp-Fix-residual-handling.patch
0004-IB-srp-Use-P_Key-cache-for-P_Key-lookups.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
