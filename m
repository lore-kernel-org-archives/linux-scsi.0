From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/11] target_core_mod: ALUA updates
Date: Wed, 16 Oct 2013 15:09:40 -0700
Message-ID: <1381961380.19256.659.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381908048-82014-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> Hi Nic,
> 
> here are some updates to TCM ALUA handling. Apart from some
> minor fixes and spellchecks the main features are:
> - Make supported states configurable:
>   We should make the list of supported ALUA states configurable,
>   as some setups would possibly like to support a small subset
>   of ALUA states only.
> - Asynchronous transitioning: I've switched 'transitioning'
>   handling to use a workqueue, that should allow us to simulate
>   asynchronous transitioning modes. IE TCM should now be capable
>   of handling requests while in transitioning, and properly terminate
>   these with the correct sense code.
> - Include target device descriptor in VPD page 83
>   For the ALUA device handler we'd need to identify the target device
>   where a given target port belongs to. So include the respective
>   values in the VPD page.
> 
> Hannes Reinecke (11):
>   target core: rename (ex,im)plict -> (ex,im)plicit
>   target_core_alua: Store supported ALUA states
>   target_core_alua: Make supported states configurable
>   target_core_alua: Rename ALUA_ACCESS_STATE_OPTIMIZED
>   target_core_alua: spellcheck
>   target_core_alua: Validate ALUA state transition
>   target_core_alua: Allocate ALUA metadata on demand
>   target_core_alua: store old and pending ALUA state
>   target_core_alua: Use workqueue for ALUA transitioning
>   target_core: simplify scsi_name_len calculation
>   target_core_spc: Include target device descriptor in VPD page 83
> 

Hey Hannes,

It looks like Patches #10 && #11 did not make it to the list.

Care to address the minor comments on the others and repost a -v2 with
the missing ones..?

--nab
