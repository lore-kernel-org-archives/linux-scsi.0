From: =?UTF-8?q?Christopher=20D=C3=ADaz=20Riveros?= <chrisadr@gentoo.org>
Subject: [PATCH-next] ibmvfc: Remove unneeded semicolons
Date: Wed, 17 Jan 2018 20:38:39 -0500
Message-ID: <20180118013839.17792-1-chrisadr@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:52572 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750948AbeARBi5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jan 2018 20:38:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au
Cc: linux-scsi@vger.kernel.org, =?UTF-8?q?Christopher=20D=C3=ADaz=20Riveros?= <chrisadr@gentoo.org>

Trivial fix removes unneeded semicolons after switch blocks.

This issue was detected by using the Coccinelle software.

Signed-off-by: Christopher Díaz Riveros <chrisadr@gentoo.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 0d2f7eb3acb6..b1b1d3a3b173 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -181,7 +181,7 @@ static void ibmvfc_trc_start(struct ibmvfc_event *evt)
 		break;
 	default:
 		break;
-	};
+	}
 }
 
 /**
@@ -220,7 +220,7 @@ static void ibmvfc_trc_end(struct ibmvfc_event *evt)
 	default:
 		break;
 
-	};
+	}
 }
 
 #else
@@ -464,7 +464,7 @@ static int ibmvfc_set_host_state(struct ibmvfc_host *vhost,
 	default:
 		vhost->state = state;
 		break;
-	};
+	}
 
 	return rc;
 }
@@ -500,7 +500,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 			break;
 		default:
 			break;
-		};
+		}
 		break;
 	case IBMVFC_HOST_ACTION_TGT_INIT:
 		if (vhost->action == IBMVFC_HOST_ACTION_ALLOC_TGTS)
@@ -515,7 +515,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 		default:
 			vhost->action = action;
 			break;
-		};
+		}
 		break;
 	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
@@ -526,7 +526,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 	default:
 		vhost->action = action;
 		break;
-	};
+	}
 }
 
 /**
@@ -1601,7 +1601,7 @@ static inline int ibmvfc_host_chkready(struct ibmvfc_host *vhost)
 	case IBMVFC_ACTIVE:
 		result = 0;
 		break;
-	};
+	}
 
 	return result;
 }
@@ -1856,7 +1856,7 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 		break;
 	default:
 		return -ENOTSUPP;
-	};
+	}
 
 	if (port_id == -1)
 		return -EINVAL;
@@ -2661,7 +2661,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 			vhost->delay_init = 1;
 			__ibmvfc_reset_host(vhost);
 			break;
-		};
+		}
 
 		break;
 	case IBMVFC_AE_LINK_UP:
@@ -2715,7 +2715,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 	default:
 		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event);
 		break;
-	};
+	}
 }
 
 /**
@@ -3351,7 +3351,7 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
 			rsp->status, rsp->error, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3451,7 +3451,7 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
 			ibmvfc_get_fc_type(be16_to_cpu(rsp->fc_type)), rsp->fc_type,
 			ibmvfc_get_ls_explain(be16_to_cpu(rsp->fc_explain)), rsp->fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3522,7 +3522,7 @@ static void ibmvfc_tgt_implicit_logout_done(struct ibmvfc_event *evt)
 	default:
 		tgt_err(tgt, "Implicit Logout failed: rc=0x%02X\n", status);
 		break;
-	};
+	}
 
 	if (vhost->action == IBMVFC_HOST_ACTION_TGT_INIT)
 		ibmvfc_init_tgt(tgt, ibmvfc_tgt_send_plogi);
@@ -3626,7 +3626,7 @@ static void ibmvfc_tgt_adisc_done(struct ibmvfc_event *evt)
 			 ibmvfc_get_fc_type(fc_reason), fc_reason,
 			 ibmvfc_get_ls_explain(fc_explain), fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3838,7 +3838,7 @@ static void ibmvfc_tgt_query_target_done(struct ibmvfc_event *evt)
 			rsp->fc_type, ibmvfc_get_gs_explain(be16_to_cpu(rsp->fc_explain)),
 			rsp->fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -4236,7 +4236,7 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_REENABLE:
 	default:
 		break;
-	};
+	}
 
 	return 1;
 }
@@ -4464,7 +4464,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	default:
 		break;
-	};
+	}
 
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 }
-- 
2.15.1
