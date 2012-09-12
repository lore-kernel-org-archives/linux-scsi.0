From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 8/15] drivers/scsi: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:15 +0200
Message-ID: <1347469402-27557-8-git-send-email-peter.senna@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/ibmvscsi/ibmvfc.c   |   36 ++++++++++++++++++------------------
 drivers/scsi/ibmvscsi/ibmvstgt.c |    2 +-
 drivers/scsi/qlogicpti.c         |    2 +-
 drivers/scsi/scsi_tgt_if.c       |    2 +-
 drivers/scsi/sgiwd93.c           |    2 +-
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 134a0ae..2d4d3b4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -176,7 +176,7 @@ static void ibmvfc_trc_start(struct ibmvfc_event *evt)
 		break;
 	default:
 		break;
-	};
+	}
 }
 
 /**
@@ -215,7 +215,7 @@ static void ibmvfc_trc_end(struct ibmvfc_event *evt)
 	default:
 		break;
 
-	};
+	}
 }
 
 #else
@@ -459,7 +459,7 @@ static int ibmvfc_set_host_state(struct ibmvfc_host *vhost,
 	default:
 		vhost->state = state;
 		break;
-	};
+	}
 
 	return rc;
 }
@@ -495,7 +495,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 			break;
 		default:
 			break;
-		};
+		}
 		break;
 	case IBMVFC_HOST_ACTION_TGT_INIT:
 		if (vhost->action == IBMVFC_HOST_ACTION_ALLOC_TGTS)
@@ -510,7 +510,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 		default:
 			vhost->action = action;
 			break;
-		};
+		}
 		break;
 	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
@@ -521,7 +521,7 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
 	default:
 		vhost->action = action;
 		break;
-	};
+	}
 }
 
 /**
@@ -1593,7 +1593,7 @@ static inline int ibmvfc_host_chkready(struct ibmvfc_host *vhost)
 	case IBMVFC_ACTIVE:
 		result = 0;
 		break;
-	};
+	}
 
 	return result;
 }
@@ -1653,7 +1653,7 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 		case MSG_ORDERED_TAG:
 			vfc_cmd->iu.pri_task_attr = IBMVFC_ORDERED_TASK;
 			break;
-		};
+		}
 	}
 
 	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev))))
@@ -1857,7 +1857,7 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 		break;
 	default:
 		return -ENOTSUPP;
-	};
+	}
 
 	if (port_id == -1)
 		return -EINVAL;
@@ -2586,7 +2586,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 			vhost->delay_init = 1;
 			__ibmvfc_reset_host(vhost);
 			break;
-		};
+		}
 
 		break;
 	case IBMVFC_AE_LINK_UP:
@@ -2638,7 +2638,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 	default:
 		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event);
 		break;
-	};
+	}
 }
 
 /**
@@ -3306,7 +3306,7 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 			ibmvfc_get_cmd_error(rsp->status, rsp->error),
 			rsp->status, rsp->error, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3402,7 +3402,7 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
 			ibmvfc_get_fc_type(rsp->fc_type), rsp->fc_type,
 			ibmvfc_get_ls_explain(rsp->fc_explain), rsp->fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3473,7 +3473,7 @@ static void ibmvfc_tgt_implicit_logout_done(struct ibmvfc_event *evt)
 	default:
 		tgt_err(tgt, "Implicit Logout failed: rc=0x%02X\n", status);
 		break;
-	};
+	}
 
 	if (vhost->action == IBMVFC_HOST_ACTION_TGT_INIT)
 		ibmvfc_init_tgt(tgt, ibmvfc_tgt_send_plogi);
@@ -3577,7 +3577,7 @@ static void ibmvfc_tgt_adisc_done(struct ibmvfc_event *evt)
 			 ibmvfc_get_fc_type(fc_reason), fc_reason,
 			 ibmvfc_get_ls_explain(fc_explain), fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -3789,7 +3789,7 @@ static void ibmvfc_tgt_query_target_done(struct ibmvfc_event *evt)
 			ibmvfc_get_fc_type(rsp->fc_type), rsp->fc_type,
 			ibmvfc_get_gs_explain(rsp->fc_explain), rsp->fc_explain, status);
 		break;
-	};
+	}
 
 	kref_put(&tgt->kref, ibmvfc_release_tgt);
 	ibmvfc_free_event(evt);
@@ -4190,7 +4190,7 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_REENABLE:
 	default:
 		break;
-	};
+	}
 
 	return 1;
 }
@@ -4418,7 +4418,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 		break;
 	default:
 		break;
-	};
+	}
 
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index aa7ed81..7437b5d 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -275,7 +275,7 @@ static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 					return -EIO;
 				}
 			}
-		};
+		}
 
 		rest -= mlen;
 	}
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index b191dd5..af81cb8 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1139,7 +1139,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 		case COMMAND_ERROR:
 		case COMMAND_PARAM_ERROR:
 			break;
-		};
+		}
 		sbus_writew(0, qpti->qregs + SBUS_SEMAPHORE);
 	}
 
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 6209110..878c96b 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -253,7 +253,7 @@ static ssize_t tgt_write(struct file *file, const char __user * buffer,
 		tgt_ring_idx_inc(ring);
 		event_recv_msg(ev);
 		ev->hdr.status = 0;
-	};
+	}
 
 	return count;
 }
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 3a9d85c..212e20e 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -187,7 +187,7 @@ static inline void init_hpc_chain(struct ip22_hostdata *hdata)
 		hcp++;
 		dma += sizeof(struct hpc_chunk);
 		start += sizeof(struct hpc_chunk);
-	};
+	}
 	hcp--;
 	hcp->desc.pnext = hdata->dma;
 }
