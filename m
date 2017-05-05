From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2] ibmvscsis: Do not send aborted task response
Date: Thu, 04 May 2017 20:01:10 -0700
Message-ID: <1493953270.23202.89.camel@haakon3.risingtidesystems.com>
References: <1493751261-81647-1-git-send-email-bryantly@linux.vnet.ibm.com>
         <1493783006.23202.87.camel@haakon3.risingtidesystems.com>
         <5c2536d3-7ff1-1e17-91c0-0be6a8befbfa@linux.vnet.ibm.com>
         <7d900f15-4590-5b09-0f48-8e8be862665e@linux.vnet.ibm.com>
         <6ac46ce3-77b9-c138-a1d9-fb119a98a9ea@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <6ac46ce3-77b9-c138-a1d9-fb119a98a9ea@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: Bart.VanAssche@sandisk.com, martin.petersen@oracle.com, turtle.in.the.kernel@gmail.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-05-04 at 18:13 -0500, Bryant G. Ly wrote:
> 
>
> Sorry Nick, but can you hold off on this patch. We are still getting extra responses but in a small timing window.
> 
> The majority of the aborts work but if we get an abort between LIO calling queue_state and LIO calling release_cmd, we get an extra response.
> 
> 
> Working on a solution, and will still have to do the tests where we basically send aborts over and over on the client btwn random timing widows.
> 

Sure, dropping this patch for now.
