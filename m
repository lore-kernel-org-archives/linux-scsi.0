From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 05/32] target: Rename some list heads used as nodes
Date: Mon, 16 Dec 2013 12:45:10 -0800
Message-ID: <1387226710.20247.196.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-6-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-6-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Since everything's a list_head, naming it _node makes it clearer it's
> to put the struct on a list, not a list head itself.
> 
> Rename ua_nacl_list to ua_nacl_node
> Rename alua_port_list to alua_port_node
> Rename lu_gp_mem_list to lu_gp_mem_node
> Rename tg_pt_gp_mem_list to tg_pt_gp_mem_node
> Rename sep_list to sep_node
> Rename tg_pt_gp_list to tg_pt_gp_node
> Rename se_session sess_list to sess_node
> Rename se_node_acl acl_list to acl_node
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c       |    2 +-
>  drivers/target/iscsi/iscsi_target_login.c |    4 +-
>  drivers/target/sbp/sbp_target.c           |    6 ++--
>  drivers/target/target_core_alua.c         |   52 ++++++++++++++--------------
>  drivers/target/target_core_configfs.c     |    4 +-
>  drivers/target/target_core_device.c       |   18 +++++-----
>  drivers/target/target_core_pr.c           |    8 ++--
>  drivers/target/target_core_tpg.c          |   20 +++++-----
>  drivers/target/target_core_transport.c    |    8 ++--
>  drivers/target/target_core_ua.c           |   28 ++++++++--------
>  drivers/target/target_core_xcopy.c        |    6 ++--
>  drivers/target/tcm_fc/tfc_conf.c          |    2 +-
>  include/target/target_core_base.h         |   16 ++++----
>  13 files changed, 87 insertions(+), 87 deletions(-)

Holding off on this one for the moment, as it conflict's with Hannes's
patches for ALUA + Referrals.

--nab
