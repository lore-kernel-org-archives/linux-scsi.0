From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 00/15, v3] Make ib_srp better suited for H.A. purposes
Date: Sun, 25 Mar 2012 14:45:44 +0000
Message-ID: <5207288.nSt5MkVMpO@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This patch series makes the ib_srp driver better suited for use in a H.A. setup because:
- Switchover can be triggered explicitly by deleting an initiator device.
- Disconnecting from a target without unloading ib_srp becomes possible.

Changes since v2:
- Addressed the v2 review comments.
- Dropped the patches that have already been merged.
- Dropped the patches for integration with multipathd.
- Dropped the micro-optimization of the IB completion handlers.

The individual patches are:
0001-ib_srp-Enlarge-block-layer-timeout.patch
0002-ib_srp-Introduce-srp_handle_qp_err.patch
0003-ib_srp-Micro-optimize-srp_queuecommand.patch
0004-ib_srp-Suppress-superfluous-error-messages.patch
0005-ib_srp-Avoid-that-error-handling-triggers-a-crash.patch
0006-ib_srp-Introduce-the-helper-function-srp_remove_targ.patch
0007-ib_srp-Eliminate-state-SRP_TARGET_DEAD.patch
0008-ib_srp-Fix-race-triggered-by-module-removal.patch
0009-srp_transport-Fix-atttribute-registration.patch
0010-srp_transport-Simplify-attribute-initialization-code.patch
0011-srp_transport-Document-sysfs-attributes.patch
0012-ib_srp-Document-sysfs-attributes.patch
0013-ib_srp-Allow-SRP-disconnect-through-sysfs.patch
0014-ib_srp-Introduce-temporary-variable-in-srp_remove_ta.patch
0015-ib_srp-Maintain-a-single-connection-per-I_T-nexus.patch


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
